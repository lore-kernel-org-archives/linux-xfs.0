Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADCAB7F3F
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 01:41:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3CFDAAC001
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 23:41:40 -0700 (PDT)
Received: from Axlion.ocius.nl (Axlion.ocius.nl [178.18.143.21]) by
	cuda.sgi.com with ESMTP id f1ziHDyaom57C34x (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Oct 2014 23:41:35 -0700 (PDT)
Received: from [94.103.146.186] (helo=MacBook-Pro-Retina-van-Stefan.local)
	by Axlion.ocius.nl with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.83) (envelope-from <stefan@ocius.nl>) id 1XgSwW-000Aub-Vt
	for xfs@oss.sgi.com; Tue, 21 Oct 2014 08:29:17 +0200
Message-ID: <5446001A.5000909@ocius.nl>
Date: Tue, 21 Oct 2014 08:41:30 +0200
From: "Stefan Bottelier | Ocius.nl" <stefan@ocius.nl>
MIME-Version: 1.0
Subject: High I/O waits
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

We have change ore servers from Linux kernel 3.2.63 to 3.12.30, and now 
we have very more I/O waits on the block device.
Are the some big changes in this version ? And we mount now with /sdb 
/srv but are the some mount options for better performance ?

I hope somebody can help me with this.

-- 
Met vriendelijke groet,

Stefan Bottelier
Ocius Internet Services

E: Stefan.Bottelier@ocius.nl
T: +31 (0)20 716 39 09
W: http://www.ocius.nl

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
