/opt/mssql/bin/sqlservr &
echo "Esperando a que SQL Server inicie..."
sleep 10
echo "Ejecutando script.sql..."
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P Password123! -C -d master -i /var/opt/mssql/init-scripts/init.sql
wait