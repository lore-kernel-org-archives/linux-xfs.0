Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nANJcOTh040594 for <xfs@oss.sgi.com>; Mon, 23 Nov 2009 13:38:24 -0600
Received: from mail-vw0-f179.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 568DAA937F
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2009 11:38:49 -0800 (PST)
Received: from mail-vw0-f179.google.com (mail-vw0-f179.google.com
	[209.85.212.179]) by cuda.sgi.com with ESMTP id
	aXfgeW9UVGzjDTuY for <xfs@oss.sgi.com>;
	Mon, 23 Nov 2009 11:38:49 -0800 (PST)
Received: by vws9 with SMTP id 9so1608185vws.20
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2009 11:38:49 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 24 Nov 2009 04:38:49 +0900
Message-ID: <5335cda50911231138u45e828afn5c30da531fbb4c09@mail.gmail.com>
Subject: can convert XFS log version from 1 to 2 ?
From: akira matsumoto <ryo.mtmt@gmail.com>
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

Hi. I'm using XFS on CentOS 5.4 now.

and I want to convert XFS log version from 1 to 2.(maybe default version is 1 )

XFS have any convert methods ? like "ext3 to XFS"

or Only could mkfs.xfs command ?

thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
