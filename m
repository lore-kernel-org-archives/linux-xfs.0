Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 Jul 2008 09:35:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6JGYruj022930
	for <xfs@oss.sgi.com>; Sat, 19 Jul 2008 09:34:53 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C51B23080E3
	for <xfs@oss.sgi.com>; Sat, 19 Jul 2008 09:36:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id PWtXntGSKDLmr9tM for <xfs@oss.sgi.com>; Sat, 19 Jul 2008 09:36:02 -0700 (PDT)
Message-ID: <63536.209.191.209.36.1216485361.squirrel@sandeen.net>
In-Reply-To: <48815AA6.3080102@sgi.com>
References: <4880AEF8.2080906@cape-horn-eng.com> <48815AA6.3080102@sgi.com>
Date: Sat, 19 Jul 2008 11:36:01 -0500 (CDT)
Subject: Re: XFS internal error xfs_btree_check_lblock
From: sandeen@sandeen.net
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Richard Ems <richard.ems@cape-horn-eng.com>, xfs@oss.sgi.com, Bill O'Donnell <billodo@sgi.com>

> Hi Richard,
>
> this looks like XFS b-tree corruption of some sort. We have some patches
> that should help here. The patches are being back-ported to SLES10 and
> should also apply to OpenSUSE. We should have something ready early next
> week.

(oops this time to the list)

Mark, are these corruptions that are already fixed upstream?  Any pointers
to the commits if so, or bugs/reviews if not?

Thanks,
-Eric
