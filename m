Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n69F2a3n035469 for <xfs@oss.sgi.com>; Thu, 9 Jul 2009 10:02:36 -0500
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C32B3133A73D
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2009 08:03:12 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154])
	by cuda.sgi.com with ESMTP id GU3weSDmjcBST87g for
	<xfs@oss.sgi.com>; Thu, 09 Jul 2009 08:03:12 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id l27so1320168fgb.8
	for <xfs@oss.sgi.com>; Thu, 09 Jul 2009 08:03:11 -0700 (PDT)
Message-ID: <4A5606A7.7070109@gmail.com>
Date: Thu, 09 Jul 2009 17:03:03 +0200
From: Tomek Kruszona <bloodyscarion@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs_repair stops on "traversing filesystem..."
References: <4A55FAF7.5040908@gmail.com> <4A560497.7@sandeen.net>
In-Reply-To: <4A560497.7@sandeen.net>
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
To: xfs@oss.sgi.com

Eric Sandeen wrote:
> You might try running with -P, though I doubt that's the issue.
> 
> If that doesn't help, you could provide an xfs_metadump image (in public
> or to me in private) and I'll take a look to see what's going on.

Thank you! I will just left xfs_repair -P to do the job and let you know
if it helps. Otherwise, I'll send you metadump image in private.

Best regards,
Tomasz Kruszona

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
