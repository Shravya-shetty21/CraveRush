package com.craverush.constants;

public final class AppConstants {

    private AppConstants() {
    }

    public static final String SESSION_USER     = "loggedInUser";
    public static final String SESSION_ADMIN    = "loggedInAdmin";
    public static final String SESSION_CART_COUNT = "cartCount";

    public static final String ORDER_PLACED     = "PLACED";
    public static final String ORDER_CONFIRMED  = "CONFIRMED";
    public static final String ORDER_PREPARING  = "PREPARING";
    public static final String ORDER_OUT_FOR_DELIVERY = "OUT_FOR_DELIVERY";
    public static final String ORDER_DELIVERED  = "DELIVERED";
    public static final String ORDER_CANCELLED  = "CANCELLED";

    public static final String PAY_COD          = "COD";
    public static final String PAY_ONLINE       = "ONLINE";

    public static final String PAY_PENDING      = "PENDING";
    public static final String PAY_COMPLETED    = "COMPLETED";
    public static final String PAY_FAILED       = "FAILED";

    public static final double DELIVERY_FEE     = 40.00;
    public static final double TAX_RATE         = 0.05;
    public static final int    SESSION_TIMEOUT  = 1800;
}
