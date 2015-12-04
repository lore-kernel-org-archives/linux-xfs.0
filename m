Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88C9D7F37
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 06:04:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7920C30405F
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 04:04:08 -0800 (PST)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25]) by
	cuda.sgi.com with ESMTP id iZCbceSlgFPsHQRZ (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Dec 2015 04:04:06 -0800 (PST)
Received: from epcpsbgr2.samsung.com
	(u142.gpu120.samsung.co.kr [203.254.230.142])
	by mailout2.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYU01HLU1ISRG40@mailout2.samsung.com> for
	xfs@oss.sgi.com; Fri, 04 Dec 2015 21:04:04 +0900 (KST)
Date: Fri, 04 Dec 2015 12:04:04 +0000 (GMT)
From: VIVEK TRIVEDI <t.vivek@samsung.com>
Subject: Re: Re: [PATCH 04/11] xfsprogs: xfsdb: remove unnessary checks in
	process_leaf_node_dir_v2_free
MIME-version: 1.0
MIME-version: 1.0
Message-id: <979512042.283901449230644012.JavaMail.weblogic@epmlwas07c>
Reply-To: t.vivek@samsung.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: AMIT SAHRAWAT <a.sahrawat@samsung.com>, PANKAJ MISHRA <pankaj.m@samsung.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

>Pretty meaningless, but I think we made this change libxfs code some
>time ago, so we may as well change it here....
thanks for review!
I will resend updated patch.
thanks!
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
