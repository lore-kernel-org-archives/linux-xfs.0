Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5ACC7F4C
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 10:57:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52CF5AC004
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 08:56:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Qt2MqIqCLrHMGzHn for <xfs@oss.sgi.com>;
	Wed, 17 Apr 2013 08:56:56 -0700 (PDT)
References: <20120828172605.607853317@sgi.com>
	<20120828172928.999971219@sgi.com>
	<CAFZPdfgFjRS2rFUekfSr4dT+-sfuji-0uUo1i7VE6=9GZOnzfg@mail.gmail.com>
	<516EB6E3.9040903@sgi.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <516EB6E3.9040903@sgi.com>
Message-Id: <943C7038-15A1-4C60-B776-F10F305F5BA9@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/5] xfstests: Use libtool to install applications
Date: Wed, 17 Apr 2013 08:56:50 -0700
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Boris Ranto <ranto.boris@gmail.com>, Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Apr 17, 2013, at 7:51 AM, Rich Johnston <rjohnston@sgi.com> wrote:

> Boris,
> 
> Most people do not install xfstests, as it is not required to run the tests.  Is there a reason you need to install xfstests? It is designed to be run from the directory you did the git clone from.  Path is not critical so you could move it anywhere you wish.
> 
Just fwiw I've always wished for a properly installable xfstests to make it possible to package it... Just a thought. :)

-Eric

> i.e.
> git clone git://oss.sgi.com/xfs/cmds/xfstests
> mv xfstests /new/path/new_xfsdirname
> cd /new/path/new_xfsdirname
> ./check -g auto
> 
> 
> --Rich
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
