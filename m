Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21963 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdIPAJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2017 20:09:44 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8G09gw1023834
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 16 Sep 2017 00:09:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8G09gns021404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 16 Sep 2017 00:09:42 GMT
Received: from ubhmp0005.oracle.com (ubhmp0005.oracle.com [156.151.24.58])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8G09g6P027578
        for <linux-xfs@vger.kernel.org>; Sat, 16 Sep 2017 00:09:42 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Status Report 9/8/2012 - 9/15/2017
Message-ID: <bfd882a4-a457-9b3b-3e3a-1fcca1531ff5@oracle.com>
Date: Fri, 15 Sep 2017 17:09:41 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


Status Report 9/8/2012 - 9/15/2017
   * Resolved lock bug found last week

   * Ran the set through xfs tests for attributes and found a few
     more bugs

   * Looks like I may need to go through the attribute code and remove
     all uses of strlen for the attribute names since parent pointer
     names are binary

   * Also reviewed documentation for xfs-delayed-logging-design to
     better understand delayed operations

Projection for next week
   * continue to stabilize and finish out the set

Vacation planned: 9/25th - 9/29th

Thanks all!
Allison Henderson
