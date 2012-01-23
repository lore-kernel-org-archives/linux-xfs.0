Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NHWnPL122959 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 11:32:49 -0600
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159]) by
	cuda.sgi.com with ESMTP id MgACEcCxTVC9N8CF for
	<xfs@oss.sgi.com>; Mon, 23 Jan 2012 09:32:48 -0800 (PST)
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 23 Jan 2012 10:32:47 -0700
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id BBB043E40059
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:32:44 -0700 (MST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q0NHWif9274498 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 12:32:44 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q0NHWiNr026721 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 15:32:44 -0200
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 23 Jan 2012 11:32:43 -0600
Message-Id: <20120123173243.31735.37262.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [PATCH 0/4] xfsprogs: Allow pquota and gquota to be used together
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Hello All,

These are the set of changes that are need to the user space code
to support pquota and gquota together.

Regards,

chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
