Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Mar 2008 13:35:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2NKZM9s005004
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 13:35:22 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0935C6D9888
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 13:35:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id TDZ0wFD6BUbkXLmW for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 13:35:51 -0700 (PDT)
Message-ID: <47E6BDC3.7030107@sandeen.net>
Date: Sun, 23 Mar 2008 15:29:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: call _notrun in common.dump if dump utils not
 found
References: <47E5CFBA.7060405@sandeen.net> <20080323054136.GA7529@puku.stupidest.org>
In-Reply-To: <20080323054136.GA7529@puku.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Chris Wedgwood wrote:
> On Sat, Mar 22, 2008 at 10:34:18PM -0500, Eric Sandeen wrote:
> 
>> it may not always be obvious to outsiders that xfsdump is packaged
>> separately from xfsprogs... is it worth checking for the binaries
>> rather than spewing verbose failures if it's not installed?
> 
> I really think xfsdump & fsr should be moved to xfsprogs.
> 

wouldn't bother me...

tests should probably require the executable either way :)

-Eric
