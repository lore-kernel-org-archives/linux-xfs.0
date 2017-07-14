Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22103 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbdGNEyO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2017 00:54:14 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6E4sDLq011251
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2017 04:54:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v6E4sDFG008226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2017 04:54:13 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v6E4sBpY016470
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2017 04:54:12 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Parent pointers
Message-ID: <59684E6E.4030806@oracle.com>
Date: Thu, 13 Jul 2017 21:54:06 -0700
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
