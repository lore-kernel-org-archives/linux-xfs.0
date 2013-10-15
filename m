Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5CC8C7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 16:31:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C5F3304032
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 14:31:12 -0700 (PDT)
Date: Tue, 15 Oct 2013 14:31:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: projid32bit=1 default in xfsprogs-3.2.0
Message-ID: <20131015213110.GA5895@infradead.org>
References: <525C1C15.7020204@sandeen.net> <20131014211659.GI5663@dastard>
	<20131014212347.GB1935@sgi.com> <525C6108.6010108@sandeen.net>
	<20131015194609.GC32095@infradead.org>
	<20131015204342.GA24997@infradead.org>
	<20131015212214.GC1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131015212214.GC1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 15, 2013 at 04:22:14PM -0500, Ben Myers wrote:
> The tags are out there:
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=tags

I managed to somehow miss them.  Sorry!

> That's an interesting idea.  We hadn't discussed a 3.1.12 release.  No
> particular objection to doing that, it's just that we didn't branch for the
> v3.0.5->v3.1.0 set of releases.  Maybe it is better if we all focus on 3.2.0.

With git you can easily branch from a past commit, e.g.:

hch@brick:~/work/xfsprogs$ git checkout -b release-3.1 v3.1.11
Switched to a new branch 'release-3.1'

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
