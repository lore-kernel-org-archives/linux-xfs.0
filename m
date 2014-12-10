Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CDE4A7F3F
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 11:56:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BAD2B304067
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 09:56:04 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id RXbsFSJMBSLHuiM3
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 09:56:03 -0800 (PST)
Message-ID: <5488893D.1060401@hardwarefreak.com>
Date: Wed, 10 Dec 2014 11:56:13 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Slow dir / Performance.
References: <5486B222.4080404@sharper.nl>
In-Reply-To: <5486B222.4080404@sharper.nl>
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
To: "Stefan Bottelier | Sharper.nl" <stefan@sharper.nl>, xfs@oss.sgi.com

On 12/09/2014 02:26 AM, Stefan Bottelier | Sharper.nl wrote:
> Hello,
> 
> We have 2 Equallogic Systems, And a Dell Servers.
> 
> We have every server give a block device home dir , so the user data are
> on the home dir this is working great its format on xfs filesystem, and
> running iscsiadm version 2.0-870 with linux kernel 3.10.62
> 
> But when we logging on the server, the first time we do a dir command on
> the home dir, its take a long time when we get feedback on the dir , the
> next time is fast when we do a dir.
> Now we have users on this systems and this problem give not good
> performance on sql and websites an e-mail we are running on the server.
> 
> Are the some information how i can fix ore maybe get this problem better
> under control ?

That's not enough information to diagnose the problem.  See:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
