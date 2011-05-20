Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KMGLq7114731 for <xfs@oss.sgi.com>; Fri, 20 May 2011 17:16:22 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B4C146FDBD
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 15:16:20 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id HEct9HCquIOmRDbf
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 15:16:20 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 9B0E16C18F
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 17:16:19 -0500 (CDT)
Message-ID: <4DD6E831.9090607@hardwarefreak.com>
Date: Fri, 20 May 2011 17:16:17 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS_WANT_CORRUPTED_GOTO on repair of large myisam (mysql) table
References: <4DD097F9.6070205@zmcconsulting.com>
	<4DD09A09.30807@sandeen.net>	<4DD6D108.3010203@zmcconsulting.com>
	<4DD6D149.6050602@sandeen.net>
In-Reply-To: <4DD6D149.6050602@sandeen.net>
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

On 5/20/2011 3:38 PM, Eric Sandeen wrote:

> Good deal.  I wish there were a way to eradicate all those kmod-xfs's on Centos systems.  :(

I wish there were a way to eradicate Centos, period.  The entire distro
is obsolete before each new rev makes it out the door, and it, and its
users, simply put a drain on Red Hat, degrading the quality of both
distros to a degree.  They also put a drain on help lists.  The first
thing we have to tell Centos users on the Postfix and Dovecot lists is
"You have to upgrade to a supported version because yours has been EOL
for x years."  "But this is the latest version available, this is the
latest Centos version, just installed it yesterday."  "Grab this third
party RPM then and install it."  "What, it's unofficial?  I only install
official packages."  ...

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
