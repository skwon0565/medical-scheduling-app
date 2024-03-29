package com.techelevator.dao;

import com.techelevator.model.Availability;
import com.techelevator.model.Doctor;
import com.techelevator.model.Review;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Component
public class JdbcAvailabilityDao implements AvailabilityDao {

    private JdbcTemplate jdbcTemplate;
    public JdbcAvailabilityDao (JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Availability mapRowToAvailability(SqlRowSet row){
        Availability availability = new Availability();

        availability.setAvailabilityId(row.getInt("availability_id"));
        availability.setDoctorId(row.getInt("doctor_id"));
        availability.setDayOfTheWeek(row.getString("day_description"));
        availability.setStartTime(LocalTime.parse(row.getString ("start_time")));
        availability.setEndTime(LocalTime.parse(row.getString ("end_time")));


        return availability;
    }
    @Override
    public List<Availability> getAvailableTimes() {
        List<Availability> availability = new ArrayList<>();
        String sql = "select a.*, d.day_description from availability a " +
                "join daysOfTheWeek d on d.day_id = a.day_id";
        SqlRowSet row = jdbcTemplate.queryForRowSet(sql);
        while (row.next()) {
            availability.add(mapRowToAvailability(row));
        }
        return availability;
    }

    @Override
    public Availability getAvailabilityById(int availabilityId) {
        Availability availability = null;
        String sql = "SELECT * FROM availability a " +
                "join daysOfTheWeek d on d.day_id = a.day_id " +
                "WHERE availability_id = ?";
        SqlRowSet row = jdbcTemplate.queryForRowSet(sql, availabilityId);
        if (row.next()) {
            availability = mapRowToAvailability(row);
        }
        return availability;
    }


    @Override
    public Availability createAvailability(Availability availability) {
        SqlRowSet dayIdResults = jdbcTemplate.queryForRowSet("select day_id from daysOfTheWeek where day_description = ?", availability.getDayOfTheWeek());
        dayIdResults.next();
        int dayId = dayIdResults.getInt("day_id");

            String sql = "INSERT INTO availability (doctor_id, day_id, start_time, end_time) VALUES (?, ?, ?, ?) RETURNING availability_id;";
            int createdAvailabilityId = jdbcTemplate.queryForObject(sql, Integer.class,
                    availability.getDoctorId(), dayId, availability.getStartTime(), availability.getEndTime());

        availability.setAvailabilityId(createdAvailabilityId);

            return availability;

    }

    @Override
    public void deleteAvailability(int availabilityId) {
        String sql = "DELETE FROM availability WHERE availability_id = ?";
        jdbcTemplate.update(sql, availabilityId);
    }

    @Override
    public Availability updateAvailability(Availability availability) {

        SqlRowSet dayIdResults = jdbcTemplate.queryForRowSet("select day_id from daysOfTheWeek where day_description = ?", availability.getDayOfTheWeek());
        dayIdResults.next();
        int dayId = dayIdResults.getInt("day_id");

        String sql = "UPDATE availability SET doctor_id = ?, day_id = ?, start_time = ?, end_time = ? WHERE availability_id = ?";
        jdbcTemplate.update(sql, availability.getDoctorId(), dayId, availability.getStartTime(), availability.getEndTime(), availability.getAvailabilityId());

        return getAvailabilityById(availability.getAvailabilityId());
    }

}
