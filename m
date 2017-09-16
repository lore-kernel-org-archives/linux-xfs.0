Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25730 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdIPE1u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Sep 2017 00:27:50 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8G4RnVc016492
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 16 Sep 2017 04:27:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8G4RnE2028078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 16 Sep 2017 04:27:49 GMT
Received: from ubhmp0007.oracle.com (ubhmp0007.oracle.com [156.151.24.60])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8G4Rn6I017400
        for <linux-xfs@vger.kernel.org>; Sat, 16 Sep 2017 04:27:49 GMT
Subject: Re: Status Report 9/8/2012 - 9/15/2017
From: Allison Henderson <allison.henderson@oracle.com>
References: <bfd882a4-a457-9b3b-3e3a-1fcca1531ff5@oracle.com>
Message-ID: <04f32299-3928-93f8-40cb-33e103610f8e@oracle.com>
Date: Fri, 15 Sep 2017 21:27:48 -0700
MIME-Version: 1.0
In-Reply-To: <bfd882a4-a457-9b3b-3e3a-1fcca1531ff5@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Oops, didn't mean to send this to the mailing list.  Feel free to ignore 
for now.  Thx!


On 09/15/2017 05:09 PM, Allison Henderson wrote:
>
> Status Report 9/8/2012 - 9/15/2017
>   * Resolved lock bug found last week
>
>   * Ran the set through xfs tests for attributes and found a few
>     more bugs
>
>   * Looks like I may need to go through the attribute code and remove
>     all uses of strlen for the attribute names since parent pointer
>     names are binary
>
>   * Also reviewed documentation for xfs-delayed-logging-design to
>     better understand delayed operations
>
> Projection for next week
>   * continue to stabilize and finish out the set
>
> Vacation planned: 9/25th - 9/29th
>
> Thanks all!
> Allison Henderson

