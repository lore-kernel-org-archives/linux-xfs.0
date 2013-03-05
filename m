Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC5F47F63
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 09:46:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5BC6DAC007
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 07:46:55 -0800 (PST)
Received: from mail.vlasiu.net (mail.vlasiu.net [91.223.50.125]) by
	cuda.sgi.com with ESMTP id 91wYeCEFseuAWUDM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Mar 2013 07:46:54 -0800 (PST)
Date: Tue, 5 Mar 2013 17:46:42 +0200 (EET)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: xfs with kernel 3.8.1
In-Reply-To: <20130305154325.GJ22182@sgi.com>
Message-ID: <alpine.LRH.2.02.1303051745220.3948@mail.vlasiu.net>
References: <alpine.LRH.2.02.1303051331140.26003@mail.vlasiu.net>
	<20130305154325.GJ22182@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi!

On Tue, 5 Mar 2013, Ben Myers wrote:

>    This is fixed in 3.8.2, by 
> 
>    commit	2cd182d6f0f
> 
>    xfs: xfs_bmap_add_attrfork_local is too generic
>    commit 1e82379b018ceed0f0912327c60d73107dacbcb3 upstream. 
Thank you!


Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 44952F15
// OpenGPG-Fingerprint: 4AC5 7C26 2FE9 02DA 4906  24B2 D32B 7ED7 4495 2F15
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBCgAGBQJRNhNiAAoJENMrftdElS8VbeMP/Rl1IpHc9WmqxVN8FwnsyD+0
JJfeR1cJXnl7Yl+ATw3yaM7p2v1te6mPwevaltRGQFHpRc8XiGkkEBIYRVaqjU+x
P3OA+N0R4/N1mykDa+xGSGPjq0i4crKJtHXSyFhIJvty/HwildejyNkN/NdOsM8r
gRhBvESu0z4pSivIpRR6JghS1DRvpAM6l2DcWJuHibznOgW8CXxda4Ly3v74GXZM
wpEsDWUdUeow59duaTf6vc9K6Oxhiybw00wify/+xYEgg5ESjQ/XoyVigd2NR1sT
d9xd8Z8IxLlHEJPFAyZn/pa8AfuEWjmUVwm9BMnFt7qWmIPFzjv60dBzpssHlVFY
bt7sStqAdXpeODh5AVcxvpI2Muij4oxCPZ0x5nIm8FHpChXWDjorgTYkHp0a2RZn
qTu70jGUniM8NZo244XgqO/3LLCMh5S7T8Sg3GW+oOG+AvDD63I+AOe4LH3e1sJC
7+uG/2uuvTSUvLLQZcoSvUPvQm2p26i9WZ7OEJ++v6NcH9JD9jCgTvfroDEt0RWO
R6ulSG9msJnKK4olIzBLuaJRTFcPXieJQFXQWpxniEzWg08NpBPNEDySLK1+7Q/N
KJr0BRsH/EDgt1p0VqGkmlg4+BzHdZhkwFkYHIqyH0FEGsnbbthaqbafsp70mMkf
L2OmqQYJK60JJ8U7vinB
=aQa3
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
