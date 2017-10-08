Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:26750 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753637AbdJHXyX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Oct 2017 19:54:23 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e1LOj-0002Eg-W9
        for linux-xfs@vger.kernel.org; Mon, 09 Oct 2017 10:54:18 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e1LOj-0003dQ-Uh
        for linux-xfs@vger.kernel.org; Mon, 09 Oct 2017 10:54:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: miscellaneous fixes
Date: Mon,  9 Oct 2017 10:54:10 +1100
Message-Id: <20171008235414.13866-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Darrick,

These are fixes that have been sitting in my test tree for a while,
so I thought I better get them cleaned out and up into the main
tree. They all address recent reported problems on the list - the RT
is not directly related to a user bug report but is something I
did while looking at the recent CVE issue.

Please consider for merge.

-Dave.
