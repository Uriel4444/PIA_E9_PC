import pandas as pd
import numpy as np
from scapy.all import sniff, IP, TCP, UDP
from sklearn.ensemble import IsolationForest, RandomForestClassifier
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
from imblearn.over_sampling import SMOTE
from datetime import datetime, timedelta
import time

data = []

def packet_callback(packet):
    if IP in packet:
        src_ip = packet[IP].src
        dst_ip = packet[IP].dst
        packet_time = time.time()
        length = len(packet)

        if TCP in packet:
            protocol = "TCP"
        elif UDP in packet:
            protocol = "UDP"
        else:
            protocol = "OTHER"

        data.append([src_ip, dst_ip, protocol, length, packet_time])

def packet_capture(duration_seconds=30):
    print(f"Iniciando la captura de paquetes por {duration_seconds} segundos...")
    end_time = datetime.now() + timedelta(seconds=duration_seconds)
    
    while datetime.now() < end_time:
        sniff(prn=packet_callback, store=0, timeout=1)

    print("Captura de paquetes finalizada.")

def analyze_packets():
    # Convertir los datos a un DataFrame
    df = pd.DataFrame(data, columns=["src_ip", "dst_ip", "protocol", "length", "packet_time"])

    # Verificar si el DataFrame está vacío
    if df.empty:
        print("Error: No se capturaron suficientes paquetes para analizar.")
    else:
        # Eliminar duplicados
        df.drop_duplicates(inplace=True)

        # Procesamiento de datos
        df['protocol'] = df['protocol'].astype('category').cat.codes
        df['packet_count_src_ip'] = df.groupby('src_ip')['src_ip'].transform('count')
        df['time_diff'] = df['packet_time'].diff().fillna(0)

        # Marcar como anómalos
        df['is_anomalous'] = np.where((df['length'] > 1000) | (df['protocol'] == 2), 1, 0)

        # Validar clases
        unique_classes = df['is_anomalous'].unique()
        if len(unique_classes) < 2:
            print("Error: Necesitas al menos dos clases en 'y' para aplicar SMOTE.")
        else:
            # Rebalancear con SMOTE
            X = df[['length', 'protocol']]  # Características
            y = df['is_anomalous']  # Etiquetas
            smote = SMOTE(sampling_strategy='auto', random_state=42)
            X_resampled, y_resampled = smote.fit_resample(X, y)

            # Entrenamiento de modelos
            # División en conjuntos de entrenamiento y prueba
            X_train, X_test, y_train, y_test = train_test_split(X_resampled, y_resampled, test_size=0.2, random_state=42)

            # Validación cruzada para Isolation Forest
            try:
                isolation_forest = IsolationForest(max_samples=min(len(X_train), 100), contamination=0.1, random_state=42)
                isolation_forest.fit(X_train)
                y_pred_if = isolation_forest.predict(X_test)
                y_pred_if = np.where(y_pred_if == -1, 1, 0)

                print("Validación cruzada para Isolation Forest:")
                print(classification_report(y_test, y_pred_if))
                print("Matriz de confusión para Isolation Forest:")
                print(confusion_matrix(y_test, y_pred_if))
                print(f"Precisión (Isolation Forest): {accuracy_score(y_test, y_pred_if):.2f}")
            except Exception as e:
                print(f"Error durante el proceso de Isolation Forest: {e}")

            # Validación cruzada para Random Forest
            try:
                random_forest = RandomForestClassifier(n_estimators=100, random_state=42)
                random_forest.fit(X_train, y_train)
                y_pred_rf = random_forest.predict(X_test)

                print("Validación cruzada para Random Forest:")
                print(classification_report(y_test, y_pred_rf))
                print("Matriz de confusión para Random Forest:")
                print(confusion_matrix(y_test, y_pred_rf))
                print(f"Precisión (Random Forest): {accuracy_score(y_test, y_pred_rf):.2f}")

                # Validación cruzada adicional
                cv_scores = cross_val_score(random_forest, X_resampled, y_resampled, cv=5)
                print(f"Precisión promedio en validación cruzada (Random Forest): {cv_scores.mean():.2f}")

            except Exception as e:
                print(f"Error durante el proceso de Random Forest: {e}")
