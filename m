Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:53652 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbeJJObS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 10:31:18 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gA8dX-0002GF-Ip
        for linux-xfs@vger.kernel.org; Wed, 10 Oct 2018 18:10:27 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gA8dX-0001mE-FV
        for linux-xfs@vger.kernel.org; Wed, 10 Oct 2018 18:10:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfsprogs: build fixes for 4.19.0-rc0
Date: Wed, 10 Oct 2018 18:10:21 +1100
Message-Id: <20181010071023.6765-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi Eric,

these are fixes for the build issues I just hit after updating my
source tree to the for-next branch.

-Dave.
