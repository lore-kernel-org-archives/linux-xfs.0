Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60858 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbeIWHTb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Sep 2018 03:19:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8N1JnXO054074
        for <linux-xfs@vger.kernel.org>; Sun, 23 Sep 2018 01:23:54 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mnd5t1m0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Sep 2018 01:23:54 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8N1Nruw028603
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Sep 2018 01:23:53 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8N1NrjX022943
        for <linux-xfs@vger.kernel.org>; Sun, 23 Sep 2018 01:23:53 GMT
Date: Sat, 22 Sep 2018 18:23:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: 4.20 plans
Message-ID: <20180923012353.GS20086@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi all,

I've recovered enough to start reviewing patches and collecting up all
my scattered brains again.  Dave will handle the merge window for 4.20
and I'll take over again after -rc1 is out.  For this release, we intend
to focus on stability and defer new features until 4.21.  In other
words, we'd prefer bug fixes and cleanups only this time around.

It's nice to be back,

--D
