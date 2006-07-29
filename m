Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Jul 2006 09:53:48 -0700 (PDT)
Received: from slimak.dkm.cz (slimak.dkm.cz [62.24.64.34])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6TGrYDW029042
	for <xfs@oss.sgi.com>; Sat, 29 Jul 2006 09:53:35 -0700
From: =?iso-8859-2?Q?Ladislav_Durch=E1nek?= <durchanek@gmail.com>
Subject: Tree Quota error message suggestion
Date: Sat, 29 Jul 2006 17:53:34 +0200
Message-ID: <018a01c6b327$25bc6d40$0201a8c0@reykjavik>
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi everybody,
First at all I have to say that XFS is great. Especially its built-in quota
support is really nice thing. I found tree quotas extremely useful for
hosting servers where uploaded files are created with other owner than
customer is.

=20

But there is a one thing which could be done better I think: When I define
tree quota and user tries to exceed id, error message returned is "No space
left on device" which is not true - there is a plenty of space on device.
Only when quota is totally full, next message is "Disk quota exceeded". I
think it should be better if first message will be also "Disk quota
exceeded".

=20

Cheers

=20

            L=E1=EFa Durch=E1nek



[[HTML alternate version deleted]]
