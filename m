Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 913557CA2
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 16:49:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7E8AE304039
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 14:49:34 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VqxoQCuRWXBzOkam for <xfs@oss.sgi.com>;
	Wed, 27 Jan 2016 14:49:33 -0800 (PST)
Received: from Liberator.local (70-90-76-85-BusName-mn.hfc.comcastbusiness.net
	[70.90.76.85])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A00FB6146F33
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 16:49:33 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/2] xfsprogs: minor quota fixups
Message-ID: <56A9497C.9070400@sandeen.net>
Date: Wed, 27 Jan 2016 16:49:32 -0600
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

Small fixups encountered while digging through quota...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
