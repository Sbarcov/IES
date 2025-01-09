using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.OleDb;
using System.Windows.Forms;
using System.IO;

namespace Mascotas_Felices
{
    class clsConsultas
    {
        private OleDbConnection conexion = new OleDbConnection();
        private OleDbCommand comando = new OleDbCommand();
        private OleDbDataAdapter adaptador = new OleDbDataAdapter();

        private String cadenaDeConexion = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Veterinaria.mdb";
        private String tabla = "Consultas";
        Int32 CantidadConsultas;
        Decimal TotalCostos;
        public String[] ListarConsultas(DataGridView grid, Int32 Dueño)
        {
            String[] Datos = new String[3];
            conexion.ConnectionString = cadenaDeConexion;
            conexion.Open();

            comando.Connection = conexion;
            comando.CommandType = CommandType.TableDirect;
            comando.CommandText = tabla;

            OleDbDataReader lector = comando.ExecuteReader();
            grid.Rows.Clear();
            while (lector.Read())
            {
                if (lector.GetInt32(1) == Dueño)
                {
                    grid.Rows.Add(lector.GetDateTime(2),
                                  lector.GetString(3),
                                  lector.GetString(4),
                                  lector.GetString(5),
                                  lector.GetDecimal(6).ToString("0.00"));
                    CantidadConsultas++;
                    TotalCostos = TotalCostos + lector.GetDecimal(6);
                }
            }
            Datos[0] = CantidadConsultas.ToString();
            Datos[1] = TotalCostos.ToString();
            Datos[2] = Convert.ToString(TotalCostos /CantidadConsultas);
            CantidadConsultas = 0;
            TotalCostos = 0;
            conexion.Close();
            return Datos;
        }

        public void GenerarReporte(Int32 Dueño)
        {
            conexion.ConnectionString = cadenaDeConexion;
            conexion.Open();

            comando.Connection = conexion;
            comando.CommandType = CommandType.TableDirect;
            comando.CommandText = tabla;

            StreamWriter Ad = new StreamWriter("Reporte.txt", false);
            Ad.WriteLine("Listado de Consulas\n");

            OleDbDataReader lector = comando.ExecuteReader();

            while (lector.Read())
            {
                if (lector.GetInt32(1) == Dueño)
                {
                    Ad.Write(lector.GetDateTime(2));
                    Ad.Write("  ");
                    Ad.Write(lector.GetString(3));
                    Ad.Write("  ");
                    Ad.Write(lector.GetString(4));
                    Ad.Write("  ");
                    Ad.Write(lector.GetString(5));
                    Ad.Write("  ");
                    Ad.WriteLine(lector.GetDecimal(6).ToString("0.00") + "\n");
                    CantidadConsultas++;
                    TotalCostos = TotalCostos + lector.GetDecimal(6);
                }
            }
            Ad.Write("Cant. de consultas:");
            Ad.Write("  ");
            Ad.Write(CantidadConsultas + "\n");
            Ad.Write("Total Costos:");
            Ad.Write("  ");
            Ad.Write(TotalCostos + "\n");
            Ad.Write("Promedio:");
            Ad.Write("  ");
            Ad.WriteLine(TotalCostos / CantidadConsultas);
            CantidadConsultas = 0;
            TotalCostos = 0;
            Ad.Close();
            conexion.Close();
        }
    }
}
