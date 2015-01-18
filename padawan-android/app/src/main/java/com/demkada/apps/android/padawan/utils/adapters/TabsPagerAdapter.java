package com.demkada.apps.android.padawan.utils.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.demkada.apps.android.padawan.ui.fragments.FeedsFragment;
import com.demkada.apps.android.padawan.ui.fragments.FriendsFragment;
import com.demkada.apps.android.padawan.ui.fragments.MessagesFragment;

/**
 * Created by kadary on 08/12/2014.
 */
public class TabsPagerAdapter extends FragmentPagerAdapter {

    private int totalTabs;

    public TabsPagerAdapter(FragmentManager fm) {

        super(fm);
    }

    public TabsPagerAdapter(FragmentManager fm, int totalTabs) {
        super(fm);
        this.totalTabs = totalTabs;
    }

    @Override
    public Fragment getItem(int index) {

        switch (index) {
            case 0:
                // Feeds fragments (WAll)
                return new FeedsFragment();
            case 1:
                // Messages fragment activity
                return new MessagesFragment();
            case 2:
                //Friends fragment activity
                return new FriendsFragment();
        }

        return null;
    }

    @Override
    public int getCount() {
        // get item count - equal to number of tabs
        return totalTabs;
    }

}
