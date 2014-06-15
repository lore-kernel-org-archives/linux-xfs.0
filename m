Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 544837F3F
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2014 13:57:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CD1D1AC07B
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2014 11:57:02 -0700 (PDT)
Received: from refuge.colorado.edu (refuge.colorado.edu [128.138.128.167]) by
	cuda.sgi.com with ESMTP id ncSzWBafiecmjZU7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Jun 2014 11:57:01 -0700 (PDT)
Received: from refuge.colorado.edu (localhost [127.0.0.1])
	by refuge.colorado.edu
	(8.14.6/8.14.1/ITS-7.0/ldap2+tls+throttle+unixops) with ESMTP
	id s5FIuvQJ015400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2014 12:57:00 -0600
Received: (from rosemane@localhost)
	by refuge.colorado.edu (8.14.6/8.14.1/ITS-7.0/submit) id s5FIuv1p015399
	for xfs@oss.sgi.com; Sun, 15 Jun 2014 12:56:57 -0600
Message-Id: <201406151856.s5FIuv1p015399@refuge.colorado.edu>
Subject: v5 on-disk format
From: Eric Roseman <Eric.Roseman@Colorado.EDU>
Date: Sun, 15 Jun 2014 18:56:57 +0000
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

With the new v5 on-disk format is there a way upgrade existing file
systems, or does this require a re-mkfs?

Thanks,
Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
