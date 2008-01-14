Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 06:43:01 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0EEgvGZ005222
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 06:42:58 -0800
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8566511CC1A7
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 06:43:15 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by cuda.sgi.com with ESMTP id iKQgFKdK6yKO09D7 for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 06:43:15 -0800 (PST)
Date: Mon, 14 Jan 2008 15:43:06 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: ***** SUSPECTED SPAM *****  Re: Question related to XFS sync , especially fsync
Message-ID: <20080114144306.GA4672@citd.de>
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gopala Krishna <gopalakrishna.n.m@gmail.com>
Cc: xfs@oss.sgi.com

On 14.01.2008 17:44, Gopala Krishna wrote:
> Hi,
> I am seeing some strange problem with XFS and would like to know  the
> expected behavior and if it is faulty is there any patches to resolve the
> problem.
> 
> Problem:
> ======

...

The man-page "xfs_freeze" at least reads like it does what you want, 
i.e. it flushes everything(tm).




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.
