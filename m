Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p92F4kB6133044 for <xfs@oss.sgi.com>; Sun, 2 Oct 2011 10:04:46 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CA0A558C3D
	for <xfs@oss.sgi.com>; Sun,  2 Oct 2011 08:04:45 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id saVMTkvxMxIMYif1 for
	<xfs@oss.sgi.com>; Sun, 02 Oct 2011 08:04:45 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Switch-3.4.4/Switch-3.4.4) with ESMTP id
	p92F4gQP014694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 2 Oct 2011 15:04:44 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	p92F4f31016861
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 2 Oct 2011 15:04:42 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	p92F4a1A022895 for <xfs@oss.sgi.com>; Sun, 2 Oct 2011 10:04:36 -0500
Message-ID: <4E887D7F.2010306@oracle.com>
Date: Sun, 02 Oct 2011 23:04:31 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: SEEK_DATA/SEEK_HOLE support
Reply-To: jeff.liu@oracle.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Dear developer,

Does anyone already worked on SEEK_DATA/SEEK_HOLE for XFS? I'd like to
implement it if not. :)


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
