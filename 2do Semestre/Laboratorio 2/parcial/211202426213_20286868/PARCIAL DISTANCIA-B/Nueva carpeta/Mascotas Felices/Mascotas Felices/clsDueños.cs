using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.OleDb;
using System.Windows.Forms;

namespace Mascotas_Felices
{
    class clsDueños
    {
        private OleDbConnection conexion = new OleDbConnection();
        private OleDbCommand comando = new OleDbCommand();
        private OleDbDataAdapter adaptador = new OleDbDataAdapter();

        private String cadenaDeConexion = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Veterinaria.mdb";
        private String tabla = "Dueños";

        public void cargarDueños(ComboBox cBox)
        {
            conexion.ConnectionString = cadenaDeConexion;
            conexion.Open();

            comando.Connection = conexion;
            comando.CommandType = CommandType.TableDirect;
            comando.CommandText = tabla;

            adaptador = new OleDbDataAdapter(comando);
            DataSet dSet = new DataSet();
            adaptador.Fill(dSet, tabla);
            cBox.DataSource = dSet.Tables[tabla];
            cBox.DisplayMember = "Nombre";
            cBox.ValueMember = "idDueño";
            conexion.Close();
        }
    }
}
