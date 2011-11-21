Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALMDL0a024049 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 16:13:21 -0600
Date: Mon, 21 Nov 2011 16:13:39 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: EFSCORRUPTED on mount?
Message-ID: <20111121221339.GP29840@sgi.com>
References: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
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
To: Gregory Farnum <gregory.farnum@dreamhost.com>
Cc: xfs@oss.sgi.com

Hey Greg,

On Mon, Nov 21, 2011 at 10:06:20AM -0800, Gregory Farnum wrote:
> Is there something useful I can do about this? Data I can provide to
> help track down what broke?

It might be useful if you can provide an xfs_metadump of the filesystem.

xfs_metadump /dev/foo - | bzip2 > /tmp/foo.bz2

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
