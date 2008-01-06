Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jan 2008 15:22:44 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m06NMXKG024897
	for <xfs@oss.sgi.com>; Sun, 6 Jan 2008 15:22:38 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1DFA4ECF23
	for <xfs@oss.sgi.com>; Sun,  6 Jan 2008 15:22:47 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id DOV5lv1aOoOcUCpy for <xfs@oss.sgi.com>; Sun, 06 Jan 2008 15:22:47 -0800 (PST)
Subject: Re: how remove project quota
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <3b8ebef50712280418l663cafadm80f884f43dfd3a15@mail.gmail.com>
References: <3b8ebef50712280418l663cafadm80f884f43dfd3a15@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 10:24:46 +1100
Message-Id: <1199661886.9463.4.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nelzinho Rocha <tecnhouse@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, 2007-12-28 at 10:18 -0200, Nelzinho Rocha wrote:
> Hello,
> 
>  how remove a project quota?
> 
>  Would be sufficient remove project quota the files /etc/projid and
> /etc/projects? Or have to do something else?

See the xfs_quota man page, in particular the expert-mode "off" and
"remove" commands.

cheers.

-- 
Nathan
