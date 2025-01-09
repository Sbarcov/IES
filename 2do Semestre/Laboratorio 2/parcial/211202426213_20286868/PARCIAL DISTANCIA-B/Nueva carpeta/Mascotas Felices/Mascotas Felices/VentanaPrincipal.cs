using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Mascotas_Felices
{
    public partial class VentanaPrincipal : Form
    {
        clsConsultas consultas = new clsConsultas();
        clsDueños dueños = new clsDueños();

        public VentanaPrincipal()
        {
            InitializeComponent();
            dueños.cargarDueños(cbDueños);
        }

        private void salirToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void acercaDeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AcercaDe vAcerca = new AcercaDe();
            vAcerca.ShowDialog();
        }

        private void cmcListar_Click(object sender, EventArgs e)
        {
            Listar();
        }

        private void cmdExportar_Click(object sender, EventArgs e)
        {
            Int32 dueño = cbDueños.SelectedIndex + 1;
            consultas.GenerarReporte(dueño);
            MessageBox.Show("Archivo exportado correctamente");
            Listar();
        }
        private void Listar() //metodo aislado para forzar el listado en la grilla
        {
            Int32 dueño = cbDueños.SelectedIndex + 1;
            String[] Datos = consultas.ListarConsultas(dgvGrilla, dueño);
            totalConsultas.Text = Datos[0];
            costoTotal.Text = Datos[1];
            promedio.Text = Datos[2];
        }
    }
}
