Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 May 2008 18:45:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4J1j6sr030830
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 18:45:11 -0700
Message-ID: <4830DBC1.1060501@sgi.com>
Date: Mon, 19 May 2008 11:45:37 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] don't run test 167 if killall is not installed
References: <20080515053918.GA16530@lst.de> <482BDAC1.7070407@sgi.com> <20080515071338.GA26247@lst.de> <20080515073605.GR155679365@sgi.com> <20080515073837.GA28530@lst.de>
In-Reply-To: <20080515073837.GA28530@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Thu, May 15, 2008 at 05:36:05PM +1000, David Chinner wrote:
>>> Dave already commited the original version, but I'll send an update
>>> to use set_prog_path later today.
>> Sorry, didn't see that Tim replied as well. set_prog_path is fine
>> by me too, but stopping every test from running because killall is
>> not present is a bit of overkill, isn't it?
> 
> My plan was to use it in 167 not common.config.  But I don't really care
> either way.

Yeah, I was just meaning for 167 too.

--Tim
