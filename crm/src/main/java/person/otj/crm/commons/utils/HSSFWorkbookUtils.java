package person.otj.crm.commons.utils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import person.otj.crm.workbench.model.Activities;
import java.util.List;
public class HSSFWorkbookUtils {
    public static void getHSSFWorkbook(HSSFWorkbook wb,List<Activities> activities){

        HSSFSheet sheet = wb.createSheet("第一页");
        HSSFRow row = sheet.createRow(0);
        String columnNames[]={"名称","所有者","开始日期","结束日期"};
        HSSFCell cell=null;
        for (int i = 0; i <4 ; i++) {
            cell = row.createCell(i);
            cell.setCellValue(columnNames[i]);
        }

        for (int i =0; i <activities.size() ; i++) {
            row=sheet.createRow(i+1);
            cell = row.createCell(0);
            cell.setCellValue(activities.get(i).getName());

            cell = row.createCell(1);
            cell.setCellValue(activities.get(i).getOwner());

            cell = row.createCell(2);
            cell.setCellValue(activities.get(i).getStartDate());

            cell = row.createCell(3);
            cell.setCellValue(activities.get(i).getEndDate());
        }
    }
}
