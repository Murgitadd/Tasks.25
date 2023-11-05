using System;
using System.Data;
using System.Data.SqlClient;

namespace SpotifyApp.Services
{
    internal class SpotifySQL
    {
        private const string conn = "Server=DESKTOP-GOU1KUJ\\MSSQLSERVER01;Database=MusicApp;Trusted_Connection=true";

        public int ExecuteCommand(string cmd)
        {
            int result = 0;
            using (SqlConnection connection = new SqlConnection(conn))
            {
                try
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand(cmd, connection);
                    result = command.ExecuteNonQuery();
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
            return result;
        }

        public DataTable ExecuteQuery(string query)
        {
            DataTable table = new DataTable();
            using (SqlConnection connection = new SqlConnection(conn))
            {
                try
                {
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    adapter.Fill(table);
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
            return table;
        }
    }
}
