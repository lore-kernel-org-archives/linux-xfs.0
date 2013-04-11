Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 052C17F37
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 16:45:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C62DC8F8084
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 14:45:20 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id xqFHe6ZVSJOUGt35 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 14:45:16 -0700 (PDT)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 11 Apr 2013 15:45:16 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 1824819D8045
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 15:45:09 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r3BLjCoB134102 for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 15:45:13 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r3BLjCm4025323
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 15:45:12 -0600
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r3BLj8UQ025084 for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 15:45:09 -0600
Subject: Deprecating xfs_check
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 11 Apr 2013 16:45:08 -0500
Message-ID: <1365716708.3762.32154.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

Hello All,

Alex Elder mentioned about deprecating xfs_check, and he suggested is to
replace xfs_check command with a script, that says xfs_check is
deprecated, use "xfs_repair -n".

Sounds ok ?

Let me know if it is not the right approach.

Regards,

Chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
