Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EEE707F82
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 16:59:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BCBB330405F
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 14:59:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wwJJVv2JOlYMfwoS for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 14:59:21 -0700 (PDT)
Date: Thu, 31 Jul 2014 07:59:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_metadump from Blur Studio
Message-ID: <20140730215919.GO20518@dastard>
References: <53D93246.1070406@blur.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53D93246.1070406@blur.com>
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
To: Duane Powell <duane@blur.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 30, 2014 at 10:58:30AM -0700, Duane Powell wrote:
> XFS!,
> 
> corrupt dinode 1124573, extent total = 1, nblocks = 0.  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.

Why were you repairing the filesystem? What went wrong?

Also:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> dump to big to email, please use this ftp account.
> 
> ftp.blur.com
> user: xsi
> password: smoke.water.775

220 Blur Studio's FTP Server (ftp.blur.com)
Name (ftp.blur.com:dave): xsi
331 Username OK, please send password.
Password:
530 Login failed.
Login failed.

> ./pickup/xfs.bug.dump

Please compress it with bzip2 first - I'm upside down at the end of
a long piece of wet string, so compression of the dump image will
save a lot of time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
