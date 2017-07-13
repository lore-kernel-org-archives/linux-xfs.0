Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19975 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdGMXZ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 19:25:27 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6DNPQ3r032541
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2017 23:25:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6DNPQvR027012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2017 23:25:26 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6DNPP2B005266
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2017 23:25:26 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Parent pointers
Message-ID: <59680165.9020201@oracle.com>
Date: Thu, 13 Jul 2017 16:25:25 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

I've been doing some digging on adding parent pointers to xfs and wanted 
to send a note to folks here to get peoples opinions on it.  I got in 
touch with Brian Foster not too long ago and he had some code partially 
done from about a year or so ago (looks like it has patches from Dave 
Chinner and Mark Tinguely as well).  So I am hoping to be able to use 
what we have so far to create something updated and finished out.  I am 
still pretty new to the xfs code, so at the moment I am still just going 
through old discussion threads, and reviewing the patches.  But for the 
most part I just wanted to see what people thought and get everyone on 
board with the idea.  Suggestions and feedback are much appreciated. 
Thank you!!

Allison Henderson
