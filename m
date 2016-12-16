Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63564 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756921AbcLPEpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 23:45:31 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1cHkKb-00023j-PE
        for linux-xfs@vger.kernel.org; Fri, 16 Dec 2016 15:41:17 +1100
Received: from dave by discord.disaster.area with local (Exim 4.88)
        (envelope-from <david@fromorbit.com>)
        id 1cHkKb-0005Zj-O9
        for linux-xfs@vger.kernel.org; Fri, 16 Dec 2016 15:41:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2 0/6] xfs_io: fix up command iteration
Date: Fri, 16 Dec 2016 15:41:09 +1100
Message-Id: <20161216044115.21287-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

V2 of the xfs_io command iteration cleanup patch first posted here:

https://www.spinics.net/lists/linux-xfs/msg02696.html

No major code changes in this version - I've improved the man page
update documenting the iteration behaviour and cleaned up the typos
pointed out, but otherwise it is unchanged.

-Dave.
