Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 07:37:13 -0700 (PDT)
Received: from waldorf.loreland.org (ip186.digipost.co.nz [203.110.30.186] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6JEb8bm031938
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 07:37:10 -0700
Message-ID: <48478.193.203.83.22.1184855825.squirrel@colo.loreland.org>
In-Reply-To: <4560AB84.9060200@sandeen.net>
References: <4560AB84.9060200@sandeen.net>
Date: Fri, 20 Jul 2007 02:37:05 +1200 (NZST)
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
From: "James Braid" <jamesb@loreland.org>
Reply-To: jamesb@loreland.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> http://sandeen.net/rhel4_xfs/kernel-module-xfs-2.6.9-42.0.2.EL-0.2-1.src.rpm
>

Has anyone had any luck with getting NFS exports to work with these
updated modules? I'm not having any luck, and just getting "Permission
denied" errors when trying to mount an NFS exported filesystem using these
modules. Works fine with the stock modules from a rebuilt RHEL4 kernel.
