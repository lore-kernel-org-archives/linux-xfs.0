Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4N7bD5T123580 for <xfs@oss.sgi.com>; Wed, 23 May 2012 02:37:13 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id HBqSZVC5pIfmKFWh (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 May 2012 00:37:11 -0700 (PDT)
Date: Wed, 23 May 2012 09:36:53 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Lost patch fixing test 273?
Message-ID: <20120523073653.GA10452@quack.suse.cz>
References: <20120515124654.GE22359@quack.suse.cz>
	<4FB68744.1090304@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FB68744.1090304@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri 18-05-12 12:30:44, Eric Sandeen wrote:
> On 5/15/12 7:46 AM, Jan Kara wrote:
> >   Hi,
> > 
> >   I'm still getting failures for test 273 among other reasons because
> > http://oss.sgi.com/archives/xfs/2012-04/msg01029.html didn't get applied.
> > Why so?
> 
> are you pulling from xfstests-dev.git on kernel.org or xfstests.git from
> oss.sgi.com?
  Good question :). Actually on one machine (my devel machine) it is the
former and on another machine (the test machine) it is the latter. I've now
made both systems use kernel.org. Thanks for suggestion.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
