Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 888867F5E
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 14:46:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72E67304043
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 12:46:11 -0700 (PDT)
Date: Tue, 15 Oct 2013 12:46:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: projid32bit=1 default in xfsprogs-3.2.0
Message-ID: <20131015194609.GC32095@infradead.org>
References: <525C1C15.7020204@sandeen.net> <20131014211659.GI5663@dastard>
	<20131014212347.GB1935@sgi.com> <525C6108.6010108@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525C6108.6010108@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ben Myers <bpm@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 14, 2013 at 04:24:24PM -0500, Eric Sandeen wrote:
> Ok.  Default it is!   Thanks guys, just wanted to make sure we were
> all in agreement there.

Can we make sure this gets documented in doc/CHANGES?

I'm also pretty sure the entry for 3.2.0-alpha1 is severly lacking,
can we make sure the one for the real release is as detailed as the ones
for the previous releases?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
