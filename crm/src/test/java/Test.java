import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import java.io.File;
import java.io.IOException;
public class Test {
    public static void main(String[] args) throws IOException {
        HSSFWorkbook wb=new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("第一页");
        HSSFRow row = sheet.createRow(0);
        HSSFCellStyle cellStyle = wb.createCellStyle();

        String columnNames[]={"姓名","学号","分数","班级"};
        HSSFCell cell =null;
        for (int i=0;i<columnNames.length;i++){
            cell=row.createCell(i);
            cell.setCellValue(columnNames[i]);
        }
        for (int i=1;i<=100;i++){
            row = sheet.createRow(i);
            row.setRowStyle(cellStyle);
            for (int k=0;k<columnNames.length;k++){
                cell=row.createCell(k);
                switch (k){
                    case 0:
                        cell.setCellValue("欧桐江"+i);
                        break;
                    case 1:
                        cell.setCellValue("0104200"+i+i);
                        break;
                    case 2:
                        cell.setCellValue((i+2)*10);
                        break;
                    case 3:
                        cell.setCellValue(i+"班");
                        break;
                }

            }
        }
        wb.write(new File("d:/wb/StudentList.xls"));

    }
}
