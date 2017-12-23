Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49080 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdLWGAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Dec 2017 01:00:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN5uuro160190
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 06:00:15 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2f1hb9g0aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 06:00:15 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN60EMk001323
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 06:00:14 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN60Dik024123
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 06:00:14 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Status Report 12/5/2017 - 12/22/2017
Message-ID: <67773e67-b4e8-a0a1-6317-4b26d3dcdbb3@oracle.com>
Date: Fri, 22 Dec 2017 23:00:12 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Status Report 12/5/2017 - 12/22/2017
   * Mapped corresponding parent pointer code to xfsprogs
   * Implemented parents_by_handle stub routine in xfsprogs
     * Enabled parents command in xfs_io
   * Working on implementing xfstests
     * Needed to finish parents tool in xfs_io to use in xfstest
   * Worked with Darrick to make sure parent pointer patches and scrub 
patches in xfs_progs compile

Projection for next week
   * Finish xfs_tests and push out set for review with xfs_progs

Thanks all!

Allison Henderson
