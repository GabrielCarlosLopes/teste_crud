using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace cadastro_cervantes
{
    public partial class Form1 : Form
    {

        private string connstring = String.Format("Server={0};Port={1};" +
            "User Id={2};Password={3};Database={4};",
            "localhost", 5432, "postgres",
            "1234", "cervantes_teste"
            );

        private NpgsqlConnection conn;
        private string sql;
        private NpgsqlCommand cmd;
        private DataTable dt;
        private int rowIndex = -1;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            conn = new NpgsqlConnection(connstring);
            Select();
        }

        private void Select()
        {
            try
            {
                conn.Open();
                sql = @"select * from selectCadastro()";
                cmd = new NpgsqlCommand(sql, conn);
                dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                conn.Close();
                dgvData.DataSource = null;
                dgvData.DataSource = dt;
            }
            catch (Exception ex)
            {
                conn.Close();
                MessageBox.Show("Error"+ex.Message);
            }
        }

        private void dgvData_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if(e.RowIndex>=0)
            {
                rowIndex = e.RowIndex;
                textDescricao.Text = dgvData.Rows[e.RowIndex].Cells["descrição"].Value.ToString();
                textNumerico.Text = dgvData.Rows[e.RowIndex].Cells["numérico"].Value.ToString();
            }
        }

        private void btnInsert_Click(object sender, EventArgs e)
        {
            rowIndex = -1;
            textDescricao.Enabled = textNumerico.Enabled = true;
            textDescricao.Text = textNumerico.Text = null;
            textDescricao.Select();
        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            if(rowIndex < 0)
            {
                MessageBox.Show("please choose a register to update");
                return;
            }
            textDescricao.Enabled = textNumerico.Enabled = true;

        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            if (rowIndex < 0)
            {
                MessageBox.Show("please choose a register to delete");
                return;
            }
            try
            {
                conn.Open();
                sql = @"select * from deleteCadastro(:_id)";
                cmd = new NpgsqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("_id", int.Parse(dgvData.Rows[rowIndex].Cells["idcadastro"].Value.ToString()));
                if ((int)cmd.ExecuteScalar() == 1)
                {
                    MessageBox.Show("Delete register success");
                    rowIndex = -1;
                    conn.Close();
                    Select();
                }
                conn.Close();
            }
            catch (Exception ex)
            {
                conn.Close();
                MessageBox.Show("Delete fail. Error: " + ex.Message);
            }
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            int result = 0;
            if(rowIndex < 0) // insert
            {
                try
                {
                    conn.Open();
                    sql = @"select * from insertCadastro(:descricao, :num)";
                    cmd = new NpgsqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("descricao", textDescricao.Text);
                    cmd.Parameters.AddWithValue("num", int.Parse(textNumerico.Text));
                    result = (int)cmd.ExecuteScalar();
                    conn.Close();
                    if(result == 1)
                    {
                        MessageBox.Show("Insert new register success");
                        Select();
                    }
                    else
                    {
                        MessageBox.Show("Insert fail");
                    }
                    
                }
                catch (Exception ex)
                {
                    conn.Close();
                    MessageBox.Show("Insert fail. Error" + ex.Message);
                }
            }
            else // update
            {
                try
                {
                    conn.Open();
                    sql = @"select * from updateCadastro(:_id, :descricaonew, :numnew)";
                    cmd = new NpgsqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("_id", int.Parse(dgvData.Rows[rowIndex].Cells["idCadastro"].Value.ToString()));
                    cmd.Parameters.AddWithValue("descricaonew", textDescricao.Text);
                    cmd.Parameters.AddWithValue("numnew", int.Parse(textNumerico.Text));
                    result = (int)cmd.ExecuteScalar();
                    conn.Close();
                    if(result == 1)
                    {
                        MessageBox.Show("Update success");
                        Select();
                    }
                    else
                    {
                        MessageBox.Show("Update fail");
                    }
                    
                }
                catch (Exception ex)
                {
                    conn.Close();
                    MessageBox.Show("Update fail. Error" + ex.Message);
                }
            }
            result = 0;
            textDescricao.Text = textNumerico.Text = null;
            textDescricao.Enabled = textNumerico.Enabled = false;
        }
    }
}
