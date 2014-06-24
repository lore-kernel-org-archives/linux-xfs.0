Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E6637F58
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 11:37:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EC8B28F8084
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 09:37:26 -0700 (PDT)
Received: from mail-qa0-f44.google.com (mail-qa0-f44.google.com
	[209.85.216.44]) by cuda.sgi.com with ESMTP id uKwMgJloQmv19X0R
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Jun 2014 09:37:25 -0700 (PDT)
Received: by mail-qa0-f44.google.com with SMTP id hw13so470034qab.31
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 09:37:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53A9A64B.7030808@sandeen.net>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<53A9A295.8030302@sandeen.net>
	<CA+o=1OXJZk2XjZhtEORQesDjb3VGzM1Ddk6DGXwuLhHJUEbjPQ@mail.gmail.com>
	<53A9A64B.7030808@sandeen.net>
Date: Tue, 24 Jun 2014 18:37:24 +0200
Message-ID: <CA+o=1OUZ7w-UCJF4xVMBSU3Tt9GFyO=iJAk1p_i4Kp_e5KRHwg@mail.gmail.com>
Subject: Re: Metadata CRC error upon unclean unmount
From: Fanael Linithien <fanael4@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

2014-06-24 18:24 GMT+02:00 Eric Sandeen <sandeen@sandeen.net>:
> Is the VM using a host block device or an image file?
> What type of image file, VDI, QCOW, or?
> If an image, what type of filesystem hosts the image?
> Have you done any "VBoxManage storagectl"-type modifications to virtualbox defaults?

VDI image, hosted on NTFS, using defaults.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
