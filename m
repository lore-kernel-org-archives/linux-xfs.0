Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 08:15:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6JFFFbm009173
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 08:15:17 -0700
Message-ID: <469F8005.3080104@sandeen.net>
Date: Thu, 19 Jul 2007 10:15:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <4560AB84.9060200@sandeen.net> <48478.193.203.83.22.1184855825.squirrel@colo.loreland.org>
In-Reply-To: <48478.193.203.83.22.1184855825.squirrel@colo.loreland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: jamesb@loreland.org
Cc: xfs@oss.sgi.com

James Braid wrote:
>> http://sandeen.net/rhel4_xfs/kernel-module-xfs-2.6.9-42.0.2.EL-0.2-1.src.rpm
>>
> 
> Has anyone had any luck with getting NFS exports to work with these
> updated modules? I'm not having any luck, and just getting "Permission
> denied" errors when trying to mount an NFS exported filesystem using these
> modules. Works fine with the stock modules from a rebuilt RHEL4 kernel.

That's odd.  You have the module on the server, exporting an xfs
filesystem, and you're getting permission denied on the client?

-Eric
