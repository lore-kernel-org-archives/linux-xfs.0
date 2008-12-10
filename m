Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBA0lMQr031588 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 18:47:22 -0600
Message-ID: <493F117B.70107@sgi.com>
Date: Wed, 10 Dec 2008 11:46:51 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com>	<20081125081644.GA20644@infradead.org>	<492C0B3D.3040002@thebarn.com>	<492CA07F.1030803@sgi.com>	<492CC201.3080304@xfs.org>	<ncc3ah6lyiw.fsf@itchy.melbourne.sgi.com>	<20081209091725.GA26180@infradead.org>	<493E9AB4.1050505@xfs.org>	<nccvdtthtyi.fsf@itchy.melbourne.sgi.com>
	<493F0831.8030405@xfs.org>
In-Reply-To: <493F0831.8030405@xfs.org>
Reply-To: markgw@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com



Russell Cattelan wrote:
> Niv Sardi wrote:
>> You don't want to be pulling xfs-dev into a xfs/master tree, you should
>> setup a remote properly and have local branch tracking them.
>>
> Ya and this is a non trivial thing to do without proper instructions.

well, see the man page for: git-remote add ...
But maybe Niv could spell out some specific examples for the XFS trees

> Sigh ....
> Honestly you think ptools info is useful here?

the original document was written to help SGI internal developers
migrate from ptools to git - and given most XFS oss developers
are familiar with ptools, the analogies in that doc are probably
useful.  But whatever we put up on the wiki for longer term reference
should probably have the ptools crud stripped out.

Cheers
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
