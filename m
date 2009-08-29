Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7TK3Ydo240385 for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 15:03:49 -0500
Received: from mx2.empa.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 810B540D052
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 13:04:03 -0700 (PDT)
Received: from mx2.empa.ch (mx2.empa.ch [152.88.7.32]) by cuda.sgi.com with
	ESMTP id iDLanGOZTw6Taqux for <xfs@oss.sgi.com>;
	Sat, 29 Aug 2009 13:04:03 -0700 (PDT)
Received: from Du-Exc-Hub1.empa.emp-eaw.ch (localhost [127.0.0.1])
	by mx2.empa.ch (Spam & Virus Firewall) with ESMTP id 767BA4EAEB
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 22:03:41 +0200 (CEST)
Received: from Du-Exc-Hub1.empa.emp-eaw.ch ([152.88.6.64]) by mx2.empa.ch with
	ESMTP id jdbG3wki3hdcp3pm for <xfs@oss.sgi.com>;
	Sat, 29 Aug 2009 22:03:41 +0200 (CEST)
From: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Date: Sat, 29 Aug 2009 22:03:35 +0200
Subject: RE: xfs data loss
Message-ID: <B9A7B002C7FAFC469D4229539E909760308DA65407@DU-EXC-MAIL.empa.emp-eaw.ch>
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A975A35.3060809@sandeen.net>
	<B9A7B002C7FAFC469D4229539E909760308DA65345@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A981133.6060009@sandeen.net>
In-Reply-To: <4A981133.6060009@sandeen.net>
Content-Language: en-US
MIME-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

I would like to ask mr. Peter Grandi, whether it is really necessary to delivery ist vaste knowledge in such a harsh way.
Is this the habit of this mailing list?

Apart from that, thank you for you help. 
I understand that RAID5 is not the ideal solution for that system, and I admit that
in the urgence of solving the /md4 problem I miswrote the problem of /md6, which 
of course was "erased" and not "repaired".

But apart from that, it is not as easy to backup 20 TB, so we decided to set it as
data storage leaving the responsibilty of the backup to our users.
I do not consider it completely absurd.

Moreover, when a raid loses 2 devices, and the devices are still ok, it is possible
to reassemble the raid by assuming the devices clean.

This is not the case for /Raid/md4, where apparently all devices are there.

THanks,
Daniele

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
