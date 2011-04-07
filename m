Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p37HJ5rB120310
	for <linux-xfs@oss.sgi.com>; Thu, 7 Apr 2011 12:19:05 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 759BB1E0786D
	for <linux-xfs@oss.sgi.com>; Thu,  7 Apr 2011 10:22:21 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with SMTP id gnuESEHwtjxJr3ZU for <linux-xfs@oss.sgi.com>;
	Thu, 07 Apr 2011 10:22:21 -0700 (PDT)
Message-ID: <4D9DF2CB.1020503@sandeen.net>
Date: Thu, 07 Apr 2011 10:22:19 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs
References: <31342497.post@talk.nabble.com>
In-Reply-To: <31342497.post@talk.nabble.com>
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
To: stress_buster <leo1783@yahoo.com>
Cc: linux-xfs@oss.sgi.com

On 4/7/11 9:04 AM, stress_buster wrote:
> 
> Hi,
> 
> My xfs_repair is bit old- 2.9. version.
> I'm considering installing latest available. But just worried because this
> is my production server and has some custom apps built into my OS. 
> 
> Is upgrading xfs_repair a high risk?

No.

> Also do I need to install latest xfsprogs or anyway only to upgrade
> xfs_repair from the package?
> I'm only would need xfs_repair mostly, so doesnt matter to me leaving
> others-mkfs.xfs etc in xfsprogs at the old version if that minimises the
> risk...

if you really want to try newer xfs_repair only, just build an xfsprogs tree and run from inside the tree.

> Any thoughts?

Just upgrade.  ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
