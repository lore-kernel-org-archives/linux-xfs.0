Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SEwPc1259729 for <xfs@oss.sgi.com>; Thu, 28 May 2009 09:58:25 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4E3D1260DF8
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 08:04:40 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id KyEgvrLDByilLfIp for <xfs@oss.sgi.com>;
	Thu, 28 May 2009 08:04:40 -0700 (PDT)
Message-ID: <4A1EA62C.8060008@sandeen.net>
Date: Thu, 28 May 2009 09:56:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 7/9] Set default extN mount options
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>	<200905281111.32011@zmi.at>
	<20090528100246.GH651@infradead.org> <200905281235.21485@zmi.at>
In-Reply-To: <200905281235.21485@zmi.at>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Michael Monnerie wrote:
> On Donnerstag 28 Mai 2009 Christoph Hellwig wrote:
>>> The same for reiserfs, but I don't know if that is wanted/needed.
>> From a look at the point option parser it would need the same
>> options.
> 
> Sorry, didn't express it well. Try to clear up: I know the options are 
> needed for ACLs, as I use reiserfs a lot, but I don't know if it's in 
> the list of FSs that are to be directly supported.
> 
> mfg zmi

I'd be happy to include support for reiserfs as well.  I'd be even
happier if you tested this yourself and sent patches to make it work :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
