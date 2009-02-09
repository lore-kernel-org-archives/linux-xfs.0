Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n19Ilwqi001042 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 12:47:58 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2F3618F8A63
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 10:47:20 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id HEe7RezpC8CVQxtO for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2009 10:47:20 -0800 (PST)
Message-ID: <49906CAE.60209@sandeen.net>
Date: Mon, 09 Feb 2009 11:49:34 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: download of attr_2.4.43-1.tar.gz
References: <49906A23.2010504@pengutronix.de>
In-Reply-To: <49906A23.2010504@pengutronix.de>
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
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: xfs@oss.sgi.com

Marc Kleine-Budde wrote:
> Hello,
> 
> is ftp://oss.sgi.com/projects/xfs/cmd_tars/ still the valid download
> location for the "attr" package?
> 
> The permissions on the ftp server on
> ftp://oss.sgi.com/projects/xfs/cmd_tars/ are mixed up, so that download
> isn't possible anymore.
> 
> ncftp /projects/xfs/cmd_tars > pwd
>   ftp://oss.sgi.com/projects/xfs/cmd_tars/
> ncftp /projects/xfs/cmd_tars > dir attr_2.4.43-1.tar.gz
> -rw-rw----       116991   Jul  3  2008   attr_2.4.43-1.tar.gz
> ncftp /projects/xfs/cmd_tars > get attr_2.4.43-1.tar.gz
> get attr_2.4.43-1.tar.gz: server said: Can't open attr_2.4.43-1.tar.gz: Permission denied
> 
> cheers, Marc

Should be fixed up now, sorry for the trouble!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
