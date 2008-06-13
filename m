Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 20:44:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5D3iG0R024640
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:44:16 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F38C3C9CEF5
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:45:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id VlblGYitsfNF5oOf for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:45:12 -0700 (PDT)
Message-ID: <4851ED48.90103@sandeen.net>
Date: Thu, 12 Jun 2008 22:45:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com> <484F452A.8090909@sandeen.net> <48512A34.1020604@sandeen.net> <4851CD32.7080106@melbourne.sgi.com> <4851E774.2070401@sgi.com>
In-Reply-To: <4851E774.2070401@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Greg Banks <gnb@melbourne.sgi.com>, Timothy Shimmin <tes@sgi.com>, Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

Mark Goodwin wrote:

> struct dirent has an embedded ino_t too, so for completeness we should also
> be looking for readdir(), readdir64(), getdirentries(), 
> getdirentries64(), etc.

*sigh*

>>> I'm going to see if I can't leverage Fedora to clean some of this up.
>>>
>>> -Eric
>>>
>> Good luck with that.
> 
> Yes good luck :)
> (and the plan for statically linked apps? ...)

I plan to encourage fedora to keep discouraging them ;)

-Eric
